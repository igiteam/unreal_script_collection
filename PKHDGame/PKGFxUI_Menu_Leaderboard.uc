class PKGFxUI_Menu_Leaderboard extends PKGFxUI_Menu_Base
    config(UI);

enum ELeaderboardType
{
    ELT_Invalid,                    // 0
    ELT_Campaign,                   // 1
    ELT_DM,                         // 2
    ELT_TDM,                        // 3
    ELT_CTF,                        // 4
    ELT_SV,                         // 5
    ELT_SoloSV,                     // 6
    ELT_MAX                         // 7
};

enum EQueryType
{
    EQT_Invalid,                    // 0
    EQT_MyPosition,                 // 1
    EQT_AroundMe,                   // 2
    EQT_Friends,                    // 3
    EQT_TopPlayers,                 // 4
    EQT_MAX                         // 5
};

struct ColumnEntry
{
    var name ColumnName;
    var int Value;

    structdefaultproperties
    {
        ColumnName="None"
        Value=0
    }
};

struct UILeaderboardEntry
{
    var string PlayerName;
    var UniqueNetId PlayerID;
    var int Score;
    var int Rank;
    var array<int> Columns;

    structdefaultproperties
    {
        PlayerName=""
        PlayerID=(Uid=none)
        Score=0
        Rank=0
        Columns=none
    }
};

struct RankSlot
{
    var GFxObject SlotMC;
    var GFxClikWidget PlayerBtn;
    var GFxObject RankTF;
    var GFxObject TextTF[7];

    structdefaultproperties
    {
        SlotMC=none
        PlayerBtn=none
        RankTF=none
        TextTF[0]=none
        TextTF[1]=none
        TextTF[2]=none
        TextTF[3]=none
        TextTF[4]=none
        TextTF[5]=none
        TextTF[6]=none
    }
};

var array<UILeaderboardEntry> LeaderBoardsEntries;
var UILeaderboardEntry LocalPlayerLeaderBoardEntry;
var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject LabelsMC;
var GFxObject KoleczkoMC;
var GFxObject TitleTF;
var GFxObject KoleczkoTF;
var GFxObject LabelRankTF;
var GFxObject LabelNickTF;
var GFxObject Label1TF;
var GFxObject Label2TF;
var GFxObject Label3TF;
var GFxObject Label4TF;
var GFxObject Label5TF;
var GFxObject Label6TF;
var GFxObject Label7TF;
var GFxObject LeaderboardTypeTF;
var GFxObject LeaderboardQueryTypeTF;
var GFxObject GamerTag;
var GFxObject PlayerNumbers;
var GFxObject PlayersArrow[10];
var GFxObject ChangeLeaderboardBtn;
var GFxObject ChangeLeaderboardTypeBtn;
var GFxClikWidget BackBtn;
var RankSlot PlayerRank;
var RankSlot PlayerSlot[10];
var const localized string TitleString;
var const localized string TxtRank;
var const localized string TxtPlayerNickLive;
var const localized string TxtPlayerNickPS3;
var const localized string TxtPlayerNick;
var const localized string TxtKills;
var const localized string TxtDeaths;
var const localized string TxtScore;
var const localized string FlagScore;
var const localized string FlagReturn;
var const localized string HitTotalLB;
var const localized string GibRatioLB;
var const localized string GoldLB;
var const localized string SoulsLB;
var const localized string BunnyTotalLB;
var const localized string DemonTotalLB;
var const localized string TXTGibRatio;
var const localized string TXTGoldScore;
var const localized string TXTMatchesWon;
var const localized string TXTKD;
var const localized string TXTFlagsCaptured;
var const localized string TXTFlagsReturned;
var const localized string TXTEnemiesKilled;
var const localized string TXTMatchesPlayed;
var const localized string TitleCampaign;
var const localized string TitleSV;
var const localized string TitleDM;
var const localized string TitleTDM;
var const localized string TitleCTF;
var const localized string TXTQueryType[5];
var PKGFxUI_Menu_Leaderboard.ELeaderboardType CurrentLeaderboard;
var PKGFxUI_Menu_Leaderboard.EQueryType CurrentQueryType;
var PKLeaderboardReadBase LeaderboardStatsRead;
var OnlineStatsInterface OSI;
var int CurrentSelectedSlot;
var int CurrentTextCount;
var int CurrentRowShift;
var int CurrentPageIndex;
var int LeaderboardReadCount;
var bool bIAmBusy;

function bool Start(optional bool StartPaused = false)
{
    local int I, J;
    local WorldInfo WI;

    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = ButtonsMC.GetObject("title");
    LabelsMC = ButtonsMC.GetObject("labels");
    ChangeLeaderboardBtn = GFxClikWidget(ButtonsMC.GetObject("change_leaderboard", Class'GFxUI.GFxClikWidget'));
    ChangeLeaderboardBtn.SetString("label", Localize("CalloutButtonText_PC", "LeaderboardsChange", "PKHDGame"));
    ChangeLeaderboardTypeBtn = GFxClikWidget(ButtonsMC.GetObject("leader_type", Class'GFxUI.GFxClikWidget'));
    ChangeLeaderboardTypeBtn.SetString("label", Localize("CalloutButtonText_PC", "LeaderboardsChangeView", "PKHDGame"));
    KoleczkoMC = RootMC.GetObject("kolko").GetObject("kolecko");
    KoleczkoTF = RootMC.GetObject("kolko").GetObject("textField");
    TitleTF = TitleMC.GetObject("textField");
    LeaderboardTypeTF = ButtonsMC.GetObject("mc_leaderboard_view").GetObject("textField");
    LeaderboardQueryTypeTF = ButtonsMC.GetObject("mc_leaderboard_type").GetObject("textField");
    GamerTag = ButtonsMC.GetObject("gamertagos").GetObject("textField");
    PlayerNumbers = ButtonsMC.GetObject("mc_playernumbers").GetObject("textField");
    GamerTag.SetText(GetLP().GetNickname());
    PlayerNumbers.SetText("to jest ilosc graczowow");
    LabelRankTF = LabelsMC.GetObject("rank");
    LabelNickTF = LabelsMC.GetObject("nickname");
    Label1TF = LabelsMC.GetObject("slot1");
    Label2TF = LabelsMC.GetObject("slot2");
    Label3TF = LabelsMC.GetObject("slot3");
    Label4TF = LabelsMC.GetObject("slot4");
    Label5TF = LabelsMC.GetObject("slot5");
    Label6TF = LabelsMC.GetObject("slot6");
    Label7TF = LabelsMC.GetObject("slot7");
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x7D2
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
        ChangeLeaderboardBtn.SetBool("visible", false);
        ChangeLeaderboardTypeBtn.SetBool("visible", false);
    }
    I = 0;
    J0x7DD:

    // End:0xA72 [Loop If]
    if(I < 10)
    {
        PlayerSlot[I].SlotMC = ButtonsMC.GetObject("player" $ string(I + 1));
        PlayerSlot[I].PlayerBtn = GFxClikWidget(PlayerSlot[I].SlotMC.GetObject("nickname", Class'GFxUI.GFxClikWidget'));
        PlayersArrow[I] = PlayerSlot[I].SlotMC.GetObject("arrow");
        PlayersArrow[I].SetVisible(false);
        PlayerSlot[I].RankTF = PlayerSlot[I].SlotMC.GetObject("rank");
        J = 0;
        J0x9C2:

        // End:0xA64 [Loop If]
        if(J < 7)
        {
            PlayerSlot[I].TextTF[J] = PlayerSlot[I].SlotMC.GetObject("slot" $ string(J + 1));
            J++;
            // [Loop Continue]
            goto J0x9C2;
        }
        I++;
        // [Loop Continue]
        goto J0x7DD;
    }
    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    TitleTF.SetText(TitleString);
    LabelRankTF.SetText(TxtRank);
    // End:0xB3D
    if(WI.IsConsoleBuild(1))
    {
        LabelNickTF.SetText(TxtPlayerNickLive);        
    }
    else
    {
        // End:0xB8D
        if(WI.IsConsoleBuild(2))
        {
            LabelNickTF.SetText(TxtPlayerNickPS3);            
        }
        else
        {
            LabelNickTF.SetText(TxtPlayerNick);
        }
    }
    CurrentSelectedSlot = 0;
    CurrentRowShift = 0;
    ChangeLeaderboard(1, 4);
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');
    ButtonAliases.AddItem('GenericBack');
    ButtonAliases.AddItem('LeaderboardsChangeView');
    ButtonAliases.AddItem('LeaderboardsChange');
    ButtonAliases.AddItem('LeaderboardsScroll');
    FrontEnd.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function int TranslateLeaderboardTypeToMCIndex(PKGFxUI_Menu_Leaderboard.ELeaderboardType NewLeaderboard)
{
    switch(NewLeaderboard)
    {
        // End:0x18
        case 1:
        // End:0x1D
        case 2:
        // End:0x22
        case 3:
        // End:0x27
        case 4:
        // End:0x2C
        case 5:
        // End:0x31
        case 6:
        // End:0xFFFF
        default:
            return 1;
            break;
    }
    //return ReturnValue;    
}

function ChangeLeaderboard(PKGFxUI_Menu_Leaderboard.ELeaderboardType NewLeaderboard, PKGFxUI_Menu_Leaderboard.EQueryType NewQueryType)
{
    local int MCindex, I;

    // End:0x3A
    if((int(NewLeaderboard) == int(CurrentLeaderboard)) && int(CurrentQueryType) == int(NewQueryType))
    {
        return;
    }
    CurrentRowShift = 0;
    CurrentLeaderboard = NewLeaderboard;
    CurrentQueryType = NewQueryType;
    MCindex = TranslateLeaderboardTypeToMCIndex(NewLeaderboard);
    LabelsMC.GotoAndStopI(MCindex);
    I = 0;
    J0xBB:

    // End:0x11E [Loop If]
    if(I < 10)
    {
        PlayerSlot[I].SlotMC.GotoAndStopI(MCindex);
        I++;
        // [Loop Continue]
        goto J0xBB;
    }
    ClearLeaderBoard();
    switch(CurrentLeaderboard)
    {
        // End:0x1A1
        case 5:
            LeaderboardTypeTF.SetText(TitleSV);
            LeaderboardQueryTypeTF.SetText(TXTQueryType[int(CurrentQueryType)]);
            // End:0x3D3
            break;
        // End:0x207
        case 2:
            LeaderboardTypeTF.SetText(TitleDM);
            LeaderboardQueryTypeTF.SetText(TXTQueryType[int(CurrentQueryType)]);
            // End:0x3D3
            break;
        // End:0x26D
        case 3:
            LeaderboardTypeTF.SetText(TitleTDM);
            LeaderboardQueryTypeTF.SetText(TXTQueryType[int(CurrentQueryType)]);
            // End:0x3D3
            break;
        // End:0x2D3
        case 4:
            LeaderboardTypeTF.SetText(TitleCTF);
            LeaderboardQueryTypeTF.SetText(TXTQueryType[int(CurrentQueryType)]);
            // End:0x3D3
            break;
        // End:0x339
        case 1:
            LeaderboardTypeTF.SetText(TitleCampaign);
            LeaderboardQueryTypeTF.SetText(TXTQueryType[int(CurrentQueryType)]);
            // End:0x3D3
            break;
        // End:0x3D0
        case 6:
            LeaderboardTypeTF.SetText(Localize("PKGFxUI_Menu_SurvivalSP", "TitleString", "PKHDGame"));
            LeaderboardQueryTypeTF.SetText(TXTQueryType[int(CurrentQueryType)]);
            // End:0x3D3
            break;
        // End:0xFFFF
        default:
            break;
    }
    UpdateLeaderboard();
    ReadLeaderboard();
    //return;    
}

function ReadLeaderboard()
{
    local array<UniqueNetId> UIDList;
    local bool bQueryResult;
    local class<PKLeaderboardWriteBase> WriteClass;

    OSI = Class'Engine.GameEngine'.static.GetOnlineSubsystem().StatsInterface;
    UIDList.AddItem(GetPC().PlayerReplicationInfo.UniqueId);
    // End:0x30E
    if(NotEqual_InterfaceInterface(OSI, OnlineStatsInterface(none)))
    {
        WriteClass = ConvertLeaderBoardTypeToWriterClass(CurrentLeaderboard);
        // End:0x30E
        if(WriteClass != none)
        {
            SetBusyIndicatorVisible(true);
            LeaderboardStatsRead = new ConvertLeaderBoardTypeToReaderClass(CurrentLeaderboard);
            LeaderboardStatsRead.ViewId = WriteClass.default.ViewIds[0];
            OSI.AddReadOnlineStatsCompleteDelegate(ReadOnlineStatsComplete);
            switch(CurrentQueryType)
            {
                // End:0x1C1
                case 1:
                    bQueryResult = OSI.ReadOnlineStats(UIDList, LeaderboardStatsRead);
                    // End:0x2CD
                    break;
                // End:0x227
                case 2:
                    bQueryResult = OSI.ReadOnlineStatsByRankAroundPlayer(byte(GetLP().ControllerId), LeaderboardStatsRead, LeaderboardReadCount);
                    // End:0x2CD
                    break;
                // End:0x284
                case 3:
                    bQueryResult = OSI.ReadOnlineStatsForFriends(byte(GetLP().ControllerId), LeaderboardStatsRead);
                    // End:0x2CD
                    break;
                // End:0x2CA
                case 4:
                    bQueryResult = OSI.ReadOnlineStatsByRank(LeaderboardStatsRead, 1, LeaderboardReadCount);
                    // End:0x2CD
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x30E
            if(bQueryResult == false)
            {
                OSI.ClearReadOnlineStatsCompleteDelegate(ReadOnlineStatsComplete);
            }
        }
    }
    //return;    
}

function ReadOnlineStatsComplete(bool bWasSuccessful)
{
    local int I, J;
    local OnlineStatsRow Row;
    local UniqueNetId PlayerID;
    local SettingsData Rank, ColumnVal;
    local UILeaderboardEntry RowEntry;

    // End:0x34D
    if(bWasSuccessful)
    {
        LeaderBoardsEntries.Length = 0;
        I = 0;
        J0x24:

        // End:0x342 [Loop If]
        if(I < LeaderboardStatsRead.Rows.Length)
        {
            Row = LeaderboardStatsRead.Rows[I];
            PlayerID = Row.PlayerID;
            Rank = Row.Rank;
            // End:0x117
            if(int(Rank.Type) == int(0))
            {
                RowEntry.Rank = 0;                
            }
            else
            {
                RowEntry.Rank = Class'Engine.Settings'.static.GetSettingsDataInt(Rank);
            }
            RowEntry.PlayerID = Row.PlayerID;
            RowEntry.PlayerName = Row.NickName;
            RowEntry.Columns.Length = ColumnsCountPerLeaderboardType();
            J = 0;
            J0x201:

            // End:0x31E [Loop If]
            if(J < Row.Columns.Length)
            {
                ColumnVal = Row.Columns[J].StatValue;
                // End:0x2C1
                if(int(ColumnVal.Type) == int(0))
                {
                    RowEntry.Columns[J] = 0;                    
                }
                else
                {
                    RowEntry.Columns[J] = Class'Engine.Settings'.static.GetSettingsDataInt(ColumnVal);
                }
                J++;
                // [Loop Continue]
                goto J0x201;
            }
            LeaderBoardsEntries.AddItem(RowEntry);
            I++;
            // [Loop Continue]
            goto J0x24;
        }
        FillLeaderboardFlashControlls();
    }
    LeaderboardStatsRead = none;
    SetBusyIndicatorVisible(false);
    //return;    
}

function ReFillLeaderboardFlashControlls()
{
    ClearLeaderBoard();
    FillLeaderboardFlashControlls(true);
    //return;    
}

function FillLeaderboardFlashControlls(optional bool bIgnoreSetFocus = false)
{
    local int I, StatA, StatB, StatC;
    local string RankStr;
    local UILeaderboardEntry EmptyRowEntryForLocalPlayer;

    // End:0x160
    if(LeaderBoardsEntries.Length == 0)
    {
        EmptyRowEntryForLocalPlayer.Columns.Length = ColumnsCountPerLeaderboardType();
        EmptyRowEntryForLocalPlayer.Columns[0] = 0;
        EmptyRowEntryForLocalPlayer.Columns[1] = 0;
        EmptyRowEntryForLocalPlayer.Columns[2] = 0;
        EmptyRowEntryForLocalPlayer.Rank = 0;
        EmptyRowEntryForLocalPlayer.PlayerID = GetPC().PlayerReplicationInfo.UniqueId;
        EmptyRowEntryForLocalPlayer.PlayerName = GetLP().GetNickname();
        LeaderBoardsEntries.AddItem(EmptyRowEntryForLocalPlayer);
    }
    I = 0;
    J0x16B:

    // End:0xA4B [Loop If]
    if((I < 10) && (I + CurrentRowShift) < LeaderBoardsEntries.Length)
    {
        ShowRow(I);
        PlayerSlot[I].PlayerBtn.SetString("label", LeaderBoardsEntries[I + CurrentRowShift].PlayerName);
        // End:0x270
        if(LeaderBoardsEntries[I + CurrentRowShift].Rank == 0)
        {
            RankStr = "--";            
        }
        else
        {
            RankStr = "" $ string(LeaderBoardsEntries[I + CurrentRowShift].Rank);
        }
        PlayerSlot[I].RankTF.SetText(RankStr);
        StatA = ((LeaderBoardsEntries[I + CurrentRowShift].Columns.Length > 0) ? LeaderBoardsEntries[I + CurrentRowShift].Columns[0] : 0);
        StatB = ((LeaderBoardsEntries[I + CurrentRowShift].Columns.Length > 1) ? LeaderBoardsEntries[I + CurrentRowShift].Columns[1] : 0);
        StatC = ((LeaderBoardsEntries[I + CurrentRowShift].Columns.Length > 2) ? LeaderBoardsEntries[I + CurrentRowShift].Columns[2] : 0);
        // End:0x4FF
        if(GetPC().PlayerReplicationInfo.UniqueId == LeaderBoardsEntries[I + CurrentRowShift].PlayerID)
        {
            PlayersArrow[I].SetVisible(true);            
        }
        else
        {
            PlayersArrow[I].SetVisible(false);
        }
        switch(CurrentLeaderboard)
        {
            // End:0x647
            case 1:
                PlayerSlot[I].TextTF[0].SetText("" $ string(StatA));
                PlayerSlot[I].TextTF[1].SetText(("" $ string(ComputeRatioInPercent(StatB, StatA))) @ "%");
                PlayerSlot[I].TextTF[2].SetText("" $ string(StatC));
                // End:0xA3D
                break;
            // End:0x74B
            case 2:
                PlayerSlot[I].TextTF[0].SetText("" $ string(StatA));
                PlayerSlot[I].TextTF[1].SetText("" $ string(StatC));
                PlayerSlot[I].TextTF[2].SetText("" $ (ComputeKDString(StatA, StatB)));
                // End:0xA3D
                break;
            // End:0x84F
            case 3:
                PlayerSlot[I].TextTF[0].SetText("" $ string(StatA));
                PlayerSlot[I].TextTF[1].SetText("" $ string(StatC));
                PlayerSlot[I].TextTF[2].SetText("" $ (ComputeKDString(StatA, StatB)));
                // End:0xA3D
                break;
            // End:0x942
            case 4:
                PlayerSlot[I].TextTF[0].SetText("" $ string(StatA));
                PlayerSlot[I].TextTF[1].SetText("" $ string(StatB));
                PlayerSlot[I].TextTF[2].SetText("" $ string(StatC));
                // End:0xA3D
                break;
            // End:0x947
            case 6:
            // End:0xA3A
            case 5:
                PlayerSlot[I].TextTF[0].SetText("" $ string(StatA));
                PlayerSlot[I].TextTF[1].SetText("" $ string(StatB));
                PlayerSlot[I].TextTF[2].SetText("" $ string(StatC));
                // End:0xA3D
                break;
            // End:0xFFFF
            default:
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x16B;
    }
    // End:0xA98
    if(!bIgnoreSetFocus)
    {
        PlayerSlot[0].PlayerBtn.SetBool("focused", true);
    }
    //return;    
}

function UpdateLeaderboard()
{
    switch(CurrentLeaderboard)
    {
        // End:0xA2
        case 1:
            CurrentTextCount = 3;
            Label1TF.SetText(TxtKills);
            Label2TF.SetText(TXTGibRatio);
            Label3TF.SetText(TXTGoldScore);
            // End:0x25C
            break;
        // End:0xA7
        case 2:
        // End:0x136
        case 3:
            CurrentTextCount = 3;
            Label1TF.SetText(TxtKills);
            Label2TF.SetText(TXTMatchesWon);
            Label3TF.SetText(TXTKD);
            // End:0x25C
            break;
        // End:0x1C5
        case 4:
            CurrentTextCount = 3;
            Label1TF.SetText(TxtScore);
            Label2TF.SetText(TXTFlagsCaptured);
            Label3TF.SetText(TXTFlagsReturned);
            // End:0x25C
            break;
        // End:0x1CA
        case 6:
        // End:0x259
        case 5:
            CurrentTextCount = 3;
            Label1TF.SetText(TxtScore);
            Label2TF.SetText(TXTEnemiesKilled);
            Label3TF.SetText(TXTMatchesWon);
            // End:0x25C
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function ShowGamerCardForLocalPlayer()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerIntEx;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xDD
    if(OnlineSub != none)
    {
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
        // End:0xDD
        if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
        {
            PlayerIntEx.ShowGamerCardUI(byte(GetLP().ControllerId), LocalPlayerLeaderBoardEntry.PlayerID);
        }
    }
    //return;    
}

function bool CanOpenPlayerCard(int Index)
{
    local UniqueNetId ZeroId;

    return LeaderBoardsEntries[Index].PlayerID != ZeroId;
    //return ReturnValue;    
}

function ShowGamerCardForPlayerSlot(int Index)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerIntEx;

    // End:0x1A
    if(!CanOpenPlayerCard(Index))
    {
        return;
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x101
    if(OnlineSub != none)
    {
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
        // End:0x101
        if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
        {
            PlayerIntEx.ShowGamerCardUI(byte(GetLP().ControllerId), LeaderBoardsEntries[Index].PlayerID);
        }
    }
    //return;    
}

function OnBack(int ControllerIdx)
{
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnPlayerSelect(int SlotIdx, int ControllerIdx)
{
    ShowGamerCardForPlayerSlot(SlotIdx + CurrentRowShift);
    //return;    
}

function OnPlayerFocus(int SlotIdx)
{
    CurrentSelectedSlot = SlotIdx;
    //return;    
}

function OnCloseAnimationComplete()
{
    switch(Action)
    {
        // End:0x60
        case "back":
            // End:0x5D
            if(FrontEnd.OpenLeaderStatsScreen())
            {
                FrontEnd.CloseLeaderboardScreen();
            }
            // End:0x66
            break;
        // End:0xFFFF
        default:
            // End:0x66
            break;
            break;
    }
    Action = "";
    //return;    
}

function ShowRow(int Row)
{
    PlayerSlot[Row].PlayerBtn.SetBool("visible", true);
    PlayerSlot[Row].SlotMC.SetVisible(true);
    //return;    
}

function ClearRow(int Row)
{
    PlayerSlot[Row].PlayerBtn.SetBool("visible", false);
    PlayerSlot[Row].SlotMC.SetVisible(false);
    //return;    
}

function ClearLeaderBoard()
{
    local int I;

    // End:0x5C
    if(NotEqual_InterfaceInterface(OSI, OnlineStatsInterface(none)))
    {
        OSI.ClearReadOnlineStatsCompleteDelegate(ReadOnlineStatsComplete);
        OSI = none;
    }
    LeaderboardStatsRead = none;
    LocalPlayerLeaderBoardEntry.Rank = 0;
    LocalPlayerLeaderBoardEntry.Columns.Length = 0;
    I = 0;
    J0xAF:

    // End:0x150 [Loop If]
    if(I < 10)
    {
        PlayerSlot[I].PlayerBtn.SetBool("visible", false);
        PlayerSlot[I].SlotMC.SetVisible(false);
        I++;
        // [Loop Continue]
        goto J0xAF;
    }
    //return;    
}

function SetBusyIndicatorVisible(bool bVisible, optional string Text = "")
{
    bIAmBusy = bVisible;
    KoleczkoMC.SetVisible(bVisible);
    KoleczkoTF.SetText(Text);
    //return;    
}

function class<PKLeaderboardWriteBase> ConvertLeaderBoardTypeToWriterClass(PKGFxUI_Menu_Leaderboard.ELeaderboardType lType)
{
    local class<PKLeaderboardWriteBase> writerClass;

    writerClass = none;
    switch(lType)
    {
        // End:0x39
        case 1:
            writerClass = Class'PKLeaderboardWriteSingle';
            // End:0xC3
            break;
        // End:0x54
        case 2:
            writerClass = Class'PKLeaderboardWriteDM';
            // End:0xC3
            break;
        // End:0x6F
        case 3:
            writerClass = Class'PKLeaderboardWriteTDM';
            // End:0xC3
            break;
        // End:0x8A
        case 4:
            writerClass = Class'PKLeaderboardWriteCTF';
            // End:0xC3
            break;
        // End:0xA5
        case 5:
            writerClass = Class'PKLeaderboardWriteSV';
            // End:0xC3
            break;
        // End:0xC0
        case 6:
            writerClass = Class'PKLeaderboardWriteSingleSV';
            // End:0xC3
            break;
        // End:0xFFFF
        default:
            break;
    }
    return writerClass;
    //return ReturnValue;    
}

function class<PKLeaderboardReadBase> ConvertLeaderBoardTypeToReaderClass(PKGFxUI_Menu_Leaderboard.ELeaderboardType lType)
{
    local class<PKLeaderboardReadBase> readerClass;

    readerClass = none;
    switch(lType)
    {
        // End:0x39
        case 1:
            readerClass = Class'PKLeaderboardReadSingle';
            // End:0xC3
            break;
        // End:0x54
        case 2:
            readerClass = Class'PKLeaderboardReadDM';
            // End:0xC3
            break;
        // End:0x6F
        case 3:
            readerClass = Class'PKLeaderboardReadTDM';
            // End:0xC3
            break;
        // End:0x8A
        case 4:
            readerClass = Class'PKLeaderboardReadCTF';
            // End:0xC3
            break;
        // End:0xA5
        case 5:
            readerClass = Class'PKLeaderboardReadSV';
            // End:0xC3
            break;
        // End:0xC0
        case 6:
            readerClass = Class'PKLeaderboardReadSingleSV';
            // End:0xC3
            break;
        // End:0xFFFF
        default:
            break;
    }
    return readerClass;
    //return ReturnValue;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x38E
    if(!bIAmBusy)
    {
        // End:0x68
        if(int(InputEvent) == int(0))
        {
            // End:0x47
            if(ButtonName == 'XboxTypeS_Y')
            {
                OnYPressed();                
            }
            else
            {
                // End:0x68
                if(ButtonName == 'XboxTypeS_X')
                {
                    OnXPressed();
                }
            }
        }
        // End:0x242
        if(int(InputEvent) == int(0))
        {
            // End:0x194
            if(ButtonName == 'MouseScrollDown')
            {
                // End:0xF9
                if((++CurrentSelectedSlot > 9) || CurrentSelectedSlot > (LeaderBoardsEntries.Length - 1))
                {
                    // End:0xED
                    if(LeaderBoardsEntries.Length < 9)
                    {
                        CurrentSelectedSlot = LeaderBoardsEntries.Length - 1;                        
                    }
                    else
                    {
                        CurrentSelectedSlot = 9;
                    }
                }
                PlayerSlot[CurrentSelectedSlot].PlayerBtn.SetBool("focused", true);
                // End:0x191
                if(CurrentSelectedSlot == 9)
                {
                    // End:0x185
                    if(++CurrentRowShift > (LeaderBoardsEntries.Length - 10))
                    {
                        CurrentRowShift = LeaderBoardsEntries.Length - 10;
                    }
                    ReFillLeaderboardFlashControlls();
                    return true;
                }                
            }
            else
            {
                // End:0x242
                if(ButtonName == 'MouseScrollUp')
                {
                    // End:0x1C7
                    if(--CurrentSelectedSlot < 0)
                    {
                        CurrentSelectedSlot = 0;
                    }
                    PlayerSlot[CurrentSelectedSlot].PlayerBtn.SetBool("focused", true);
                    // End:0x242
                    if(CurrentSelectedSlot == 0)
                    {
                        // End:0x238
                        if(--CurrentRowShift < 0)
                        {
                            CurrentRowShift = 0;
                        }
                        ReFillLeaderboardFlashControlls();
                    }
                }
            }
        }
        // End:0x38E
        if((int(InputEvent) == int(0)) || int(InputEvent) == int(2))
        {
            // End:0x30C
            if((((ButtonName == 'XboxTypeS_DPad_Down') || ButtonName == 'Gamepad_LeftStick_Down') || ButtonName == 'Down') && CurrentSelectedSlot == 9)
            {
                // End:0x2FD
                if(++CurrentRowShift > (LeaderBoardsEntries.Length - 10))
                {
                    CurrentRowShift = LeaderBoardsEntries.Length - 10;
                }
                ReFillLeaderboardFlashControlls();
                return true;                
            }
            else
            {
                // End:0x38E
                if((((ButtonName == 'XboxTypeS_DPad_Up') || ButtonName == 'Gamepad_LeftStick_Up') || ButtonName == 'Up') && CurrentSelectedSlot == 0)
                {
                    // End:0x382
                    if(--CurrentRowShift < 0)
                    {
                        CurrentRowShift = 0;
                    }
                    ReFillLeaderboardFlashControlls();
                    return true;
                }
            }
        }
    }
    return super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    //return ReturnValue;    
}

function OnChangeLeaderBtn(EventData ev)
{
    OnYPressed();
    //return;    
}

function OnTypeBtn(EventData ev)
{
    OnXPressed();
    //return;    
}

function OnA(EventData ev)
{
    //return;    
}

function OnYPressed()
{
    // End:0x0F
    if(bIAmBusy)
    {
        return;
    }
    ChangeLeaderboard(NextLeaderboard(), CurrentQueryType);
    //return;    
}

function OnXPressed()
{
    local PKGFxUI_Menu_Leaderboard.EQueryType NQT;

    // End:0x0F
    if(bIAmBusy)
    {
        return;
    }
    NQT = byte(int(CurrentQueryType) + int(1));
    // End:0x4C
    if(int(NQT) >= int(5))
    {
        NQT = 1;
    }
    ChangeLeaderboard(CurrentLeaderboard, NQT);
    //return;    
}

function OnL1Pressed()
{
    //return;    
}

function OnR1(EventData ev)
{
    //return;    
}

function OnLeftPressed()
{
    // End:0x2C
    if(!bIAmBusy)
    {
        ChangeLeaderboard(PrevLeaderboard(), CurrentQueryType);
    }
    //return;    
}

function OnRightPressed()
{
    // End:0x2C
    if(!bIAmBusy)
    {
        ChangeLeaderboard(NextLeaderboard(), CurrentQueryType);
    }
    //return;    
}

function PKGFxUI_Menu_Leaderboard.ELeaderboardType NextLeaderboard()
{
    switch(CurrentLeaderboard)
    {
        // End:0x1B
        case 1:
            return 2;
        // End:0x23
        case 2:
            return 3;
        // End:0x2B
        case 3:
            return 4;
        // End:0x33
        case 4:
            return 6;
        // End:0x3B
        case 6:
            return 5;
        // End:0x43
        case 5:
            return 1;
        // End:0xFFFF
        default:
            return CurrentLeaderboard;
            break;
    }
    //return ReturnValue;    
}

function PKGFxUI_Menu_Leaderboard.ELeaderboardType PrevLeaderboard()
{
    switch(CurrentLeaderboard)
    {
        // End:0x1B
        case 1:
            return 4;
        // End:0x23
        case 2:
            return 1;
        // End:0x2B
        case 3:
            return 2;
        // End:0x33
        case 4:
            return 3;
        // End:0x3B
        case 6:
            return 4;
        // End:0x43
        case 5:
            return 6;
        // End:0xFFFF
        default:
            return CurrentLeaderboard;
            break;
    }
    //return ReturnValue;    
}

function int ColumnsCountPerLeaderboardType()
{
    switch(CurrentLeaderboard)
    {
        // End:0x18
        case 1:
        // End:0x1D
        case 2:
        // End:0x22
        case 3:
        // End:0x27
        case 4:
        // End:0x2C
        case 5:
        // End:0x31
        case 6:
        // End:0xFFFF
        default:
            return 3;
            break;
    }
    //return ReturnValue;    
}

function int ComputeRatioInPercent(int A, int B)
{
    local float Ratio;

    // End:0x48
    if((A != 0) && B != 0)
    {
        Ratio = (float(A) / float(B)) * float(100);
    }
    return int(Ratio);
    //return ReturnValue;    
}

function string ComputeKDString(int Kills, int Deaths)
{
    local string ret;
    local float Ratio;

    // End:0x32
    if((Kills == 0) || Deaths == 0)
    {
        ret = "0.0";        
    }
    else
    {
        Ratio = float(Kills) / float(Deaths);
        ret = TrimFloat("" $ string(Ratio), 2);
    }
    return ret;
    //return ReturnValue;    
}

defaultproperties
{
    TitleString="Leaderboards"
    TxtRank="RANK"
    TxtPlayerNickLive="GAMERTAG"
    TxtPlayerNickPS3="ONLINE ID"
    TxtPlayerNick="PROFILE NAME"
    TxtKills="Kills"
    TxtDeaths="Deaths"
    TxtScore="Score"
    FlagScore="Flag score"
    FlagReturn="Flags returned"
    HitTotalLB="Hit total"
    GibRatioLB="Gib ratio"
    GoldLB="Gold"
    SoulsLB="Souls"
    BunnyTotalLB="Bunny total"
    DemonTotalLB="Demon total"
    TXTGibRatio="Gib Ratio"
    TXTGoldScore="Gold Score"
    TXTMatchesWon="Matches Won"
    TXTKD="K/D"
    TXTFlagsCaptured="Flags Captured"
    TXTFlagsReturned="Flags Returned"
    TXTEnemiesKilled="Enemies Killed"
    TXTMatchesPlayed="Matches Played"
    TitleCampaign="Campaign"
    TitleSV="Survival"
    TitleDM="Deathmatch"
    TitleTDM="Team Deathmatch"
    TitleCTF="Capture The Flag"
    TXTQueryType[0]="Invalid"
    TXTQueryType[1]="Your rank"
    TXTQueryType[2]="Ranked near You"
    TXTQueryType[3]="Friends"
    TXTQueryType[4]="Top players"
    LeaderboardReadCount=100
    MovieInfo=SwfMovie'PKHD_UI.PKLeaderBoard'
}