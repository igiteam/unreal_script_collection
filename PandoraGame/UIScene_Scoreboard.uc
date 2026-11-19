class UIScene_Scoreboard extends UIScene_NetworkScene;

enum StatFieldPG1
{
    SF_TOTAL_KILLS,                 // 0
    SF_DEATHS,                      // 1
    SF_ANIMUS_DELIVERED,            // 2
    SF_TOTAL_SCORE,                 // 3
    SF_MAX                          // 4
};

enum StatFieldPG2
{
    SF_WW_KILLS,                    // 0
    SF_PLAYER_KILLS,                // 1
    SF_ANIMUS_COLLECTED,            // 2
    SF_INTERRUPT_KILLS,             // 3
    SF_MAX                          // 4
};

enum StatFieldPG3
{
    SF_ALPHA_WW_KILLS,              // 0
    SF_WEAK_WW_KILLS,               // 1
    SF_ANIMUS_FROM_WW,              // 2
    SF_ANIMUS_FROM_PLAYER,          // 3
    SF_MAX                          // 4
};

struct ColumnLabelSet
{
    var UILabel lbls[4];

    structdefaultproperties
    {
        lbls[0]=none
        lbls[1]=none
        lbls[2]=none
        lbls[3]=none
    }
};

var UIImage UIPlayerTalkingImage[8];
var UILabelButton btnPlayer[8];
var UILabel lblPlayer[8];
var string strStatHeaders[12];
var string strStatValueHeaders[12];
var ColumnLabelSet lblStats[8];
var ColumnLabelSet lblTotals[2];
var ColumnLabelSet lblStatHeaders[2];
var ColumnLabelSet lblSubStatHeaders[4];
var UILabel lblBonus[2];
var UILabel lblWinStatus;
var UILabel lblHelperText;
var UIImage imgBackground;
var UIImage imgBlueBacking;
var UIImage imgRedBacking;
var UILabel lblIntermission;
var int PRIIdx[8];
var bool bInGameMode;
var bool bLostConnectionToHost;
var bool bGRIInitialized;
var float LastUpdateTime;
var array<PlayerStats> TeamAStats;
var array<PlayerStats> TeamBStats;
var int TotalAnimusDelivered[2];
var const localized string strTeamAWins;
var const localized string strTeamBWins;
var const localized string strTie;
var int TeamAScrollPos;
var int TeamBScrollPos;
var const localized string strIntermission;
var const localized string QuitToMainMessage;
var const localized string QuitToMainTitle;
var LinearColor DisabledColor;
var LinearColor EnabledColor;
var LinearColor SelectedColor;
var UIProgressBar MMBar1;
var UIProgressBar MMBar2;
var UILabel MMLabel1;
var UILabel MMLabel2;

simulated function ResetTotals()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x2A [Loop If]
    if(I < 2)
    {
        TotalAnimusDelivered[I] = 0;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function ComputeTotals()
{
    local int I;

    ResetTotals();
    I = 0;
    J0x11:

    // End:0x4A [Loop If]
    if(I < TeamAStats.Length)
    {
        TotalAnimusDelivered[0] += TeamAStats[I].AnimusBanked;
        I++;
        // [Loop Continue]
        goto J0x11;
    }
    I = 0;
    J0x51:

    // End:0x8A [Loop If]
    if(I < TeamBStats.Length)
    {
        TotalAnimusDelivered[1] += TeamBStats[I].AnimusBanked;
        I++;
        // [Loop Continue]
        goto J0x51;
    }
    //return;    
}

simulated event int GetTotalPoints(PlayerStats Stats)
{
    local PandoraGRI PGRI;
    local int monsterMachineLevelPoints, fillLevel;
    local WorldInfo WI;
    local SPPointEventMachineBonusPersistent theMachineBonus;

    WI = Class'SPHud'.static.GetWorldInfo();
    PGRI = PandoraGRI(WI.GRI);
    // End:0x45
    if(PGRI == none)
    {
        monsterMachineLevelPoints = 0;        
    }
    else
    {
        theMachineBonus = PGRI.GetPointEventMachineBonus();
        fillLevel = theMachineBonus.GetLevelForFillPercent(int(PGRI.GetMonsterMachineValue(Stats.TeamIndex)));
        monsterMachineLevelPoints = theMachineBonus.GetPointsForLevel(fillLevel);
    }
    return int(((((((((float(Stats.KillPlayerNormalNum) * Class'SPPointEventKillPlayerNormal'.static.GetPoints()) + (float(Stats.KillPlayerInterruptNum) * Class'SPPointEventKillPlayerInterrupt'.static.GetPoints())) + (float(Stats.KillPlayerDefensiveNum) * Class'SPPointEventKillPlayerDefensive'.static.GetPoints())) + (float(Stats.KillAlphaWWNum) * Class'SPPointEventKillAlphaWW'.static.GetPoints())) + (float(Stats.KillWeakWWNum) * Class'SPPointEventKillWeakWW'.static.GetPoints())) + (float(Stats.AnimusBanked) * Class'SPPointEventAnimusBanked'.static.GetPoints())) + (float(Stats.AnimusCollectedPlayerNum) * Class'SPPointEventAnimusCollectedPlayer'.static.GetPoints())) + (float(Stats.AnimusCollectedWWNum) * Class'SPPointEventAnimusCollectedWW'.static.GetPoints())) + float(monsterMachineLevelPoints));
    //return ReturnValue;    
}

simulated function int GetTotalKills(PlayerStats Stats)
{
    return (((Stats.KillPlayerNormalNum + Stats.KillPlayerInterruptNum) + Stats.KillPlayerDefensiveNum) + Stats.KillAlphaWWNum) + Stats.KillWeakWWNum;
    //return ReturnValue;    
}

simulated function int GetTotalPlayerKills(PlayerStats Stats)
{
    return (Stats.KillPlayerNormalNum + Stats.KillPlayerInterruptNum) + Stats.KillPlayerDefensiveNum;
    //return ReturnValue;    
}

simulated function int GetTotalWWKills(PlayerStats Stats)
{
    return Stats.KillAlphaWWNum + Stats.KillWeakWWNum;
    //return ReturnValue;    
}

function PlayerStats GetStatsFromSPPRI(SPPlayerReplicationInfo SPPRI)
{
    local PlayerStats Stats;

    Stats.PlayerName = SPPRI.PlayerName;
    Stats.UniqueId = SPPRI.UniqueId;
    Stats.KillPlayerNormalNum = SPPRI.KillPlayerNormalNum;
    Stats.KillPlayerInterruptNum = SPPRI.KillPlayerInterruptNum;
    Stats.KillPlayerDefensiveNum = SPPRI.KillPlayerDefensiveNum;
    Stats.KillAlphaWWNum = SPPRI.KillAlphaWWNum;
    Stats.KillWeakWWNum = SPPRI.KillWeakWWNum;
    Stats.AnimusBanked = SPPRI.AnimusBanked;
    Stats.AnimusCollectedPlayerNum = SPPRI.AnimusCollectedPlayerNum;
    Stats.AnimusCollectedWWNum = SPPRI.AnimusCollectedWWNum;
    Stats.Deaths = int(SPPRI.Deaths);
    Stats.TeamIndex = SPPRI.Team.TeamIndex;
    return Stats;
    //return ReturnValue;    
}

function int FindTeamAStatByUID(UniqueNetId Id)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4A [Loop If]
    if(I < TeamAStats.Length)
    {
        // End:0x40
        if(TeamAStats[I].UniqueId == Id)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function int FindTeamBStatByUID(UniqueNetId Id)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4A [Loop If]
    if(I < TeamBStats.Length)
    {
        // End:0x40
        if(TeamBStats[I].UniqueId == Id)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function UpdateStatListNames()
{
    local int StatId, I;
    local PandoraGRI PGRI;
    local WorldInfo WI;
    local SPPlayerReplicationInfo SPPRI;

    WI = Class'SPHud'.static.GetWorldInfo();
    PGRI = PandoraGRI(WI.GRI);
    I = 0;
    J0x37:

    // End:0x1B9 [Loop If]
    if(I < PGRI.PRIArray.Length)
    {
        SPPRI = SPPlayerReplicationInfo(PGRI.PRIArray[I]);
        // End:0x111
        if(SPPRI.Team.TeamIndex == 1)
        {
            StatId = FindTeamAStatByUID(SPPRI.UniqueId);
            // End:0x10E
            if(StatId != -1)
            {
                // End:0x10E
                if(SPPRI.PlayerName != TeamAStats[StatId].PlayerName)
                {
                    TeamAStats[StatId].PlayerName = SPPRI.PlayerName;
                }
            }
            // [Explicit Continue]
            goto J0x1AF;
        }
        // End:0x1AF
        if(SPPRI.Team.TeamIndex == 2)
        {
            StatId = FindTeamBStatByUID(SPPRI.UniqueId);
            // End:0x1AF
            if(StatId != -1)
            {
                // End:0x1AF
                if(SPPRI.PlayerName != TeamBStats[StatId].PlayerName)
                {
                    TeamBStats[StatId].PlayerName = SPPRI.PlayerName;
                }
            }
        }
        J0x1AF:

        I++;
        // [Loop Continue]
        goto J0x37;
    }
    //return;    
}

function BuildStatLists()
{
    local PandoraGRI PGRI;
    local SPPlayerReplicationInfo SPPRI;
    local int I, J, LastTeamAIndex, LastTeamBIndex;
    local bool bFoundInPRIArray;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2A
    if(PGRI == none)
    {
    }
    TeamAStats.Length = 0;
    TeamBStats.Length = 0;
    I = 0;
    J0x41:

    // End:0x157 [Loop If]
    if(I < PGRI.PRIArray.Length)
    {
        SPPRI = SPPlayerReplicationInfo(PGRI.PRIArray[I]);
        // End:0xE5
        if(SPPRI.Team.TeamIndex == 1)
        {
            TeamAStats.Insert(TeamAStats.Length, 1);
            TeamAStats[LastTeamAIndex] = GetStatsFromSPPRI(SPPRI);
            TeamAStats[LastTeamAIndex].bInActive = false;
            LastTeamAIndex++;
            // [Explicit Continue]
            goto J0x14D;
        }
        // End:0x14D
        if(SPPRI.Team.TeamIndex == 2)
        {
            TeamBStats.Insert(TeamBStats.Length, 1);
            TeamBStats[LastTeamBIndex] = GetStatsFromSPPRI(SPPRI);
            TeamBStats[LastTeamBIndex].bInActive = false;
            LastTeamBIndex++;
        }
        J0x14D:

        I++;
        // [Loop Continue]
        goto J0x41;
    }
    I = 0;
    J0x15E:

    // End:0x349 [Loop If]
    if(I < PGRI.nSPInactiveStats)
    {
        bFoundInPRIArray = false;
        J = 0;
        J0x186:

        // End:0x247 [Loop If]
        if(J < PGRI.PRIArray.Length)
        {
            // End:0x23D
            if(PGRI.SPInactiveStats[I].UniqueId == PGRI.PRIArray[J].UniqueId && PGRI.SPInactiveStats[I].TrueUniqueId == SPPlayerReplicationInfo(PGRI.PRIArray[J]).TrueUniqueId)
            {
                bFoundInPRIArray = true;
                // [Explicit Break]
                goto J0x247;
            }
            J++;
            // [Loop Continue]
            goto J0x186;
        }
        J0x247:

        // End:0x253
        if(bFoundInPRIArray)
        {
            // [Explicit Continue]
            goto J0x33F;
        }
        // End:0x2CA
        if(PGRI.SPInactiveStats[I].TeamIndex == 1)
        {
            TeamAStats.Insert(TeamAStats.Length, 1);
            TeamAStats[LastTeamAIndex] = PGRI.SPInactiveStats[I];
            TeamAStats[LastTeamAIndex].bInActive = true;
            LastTeamAIndex++;
            // [Explicit Continue]
            goto J0x33F;
        }
        // End:0x33F
        if(PGRI.SPInactiveStats[I].TeamIndex == 2)
        {
            TeamBStats.Insert(TeamBStats.Length, 1);
            TeamBStats[LastTeamBIndex] = PGRI.SPInactiveStats[I];
            TeamBStats[LastTeamBIndex].bInActive = true;
            LastTeamBIndex++;
        }
        J0x33F:

        I++;
        // [Loop Continue]
        goto J0x15E;
    }
    //return;    
}

function InitStatLabels(int TeamID)
{
    local string strPostfix;
    local int PlayerID, R, C;

    // End:0x14
    if(TeamID == 1)
    {
        strPostfix = "B";
    }
    PlayerID = 0;
    J0x1B:

    // End:0xD8 [Loop If]
    if(PlayerID < 4)
    {
        C = 0;
        J0x2E:

        // End:0xCE [Loop If]
        if(C < 4)
        {
            R = PlayerID + (TeamID * 4);
            lblStats[R].lbls[C] = UILabel(FindChild(StringToName((("Stat" $ string(PlayerID)) $ string(C)) $ strPostfix), true));
            // End:0xC4
            if(lblStats[R].lbls[C] == none)
            {
            }
            C++;
            // [Loop Continue]
            goto J0x2E;
        }
        PlayerID++;
        // [Loop Continue]
        goto J0x1B;
    }
    C = 0;
    J0xDF:

    // End:0x247 [Loop If]
    if(C < 4)
    {
        lblStatHeaders[TeamID].lbls[C] = UILabel(FindChild(StringToName(("MainStatHeader" $ string(C)) $ strPostfix), true));
        // End:0x160
        if(lblStatHeaders[TeamID].lbls[C] == none)
        {
        }
        lblSubStatHeaders[TeamID].lbls[C] = UILabel(FindChild(StringToName(("StatHeader" $ string(C)) $ strPostfix), true));
        // End:0x1D1
        if(lblSubStatHeaders[TeamID].lbls[C] == none)
        {
        }
        lblTotals[TeamID].lbls[C] = UILabel(FindChild(StringToName(("Total" $ string(C)) $ strPostfix), true));
        // End:0x23D
        if(lblTotals[TeamID].lbls[C] == none)
        {
        }
        C++;
        // [Loop Continue]
        goto J0xDF;
    }
    //return;    
}

function InitLabels()
{
    InitStatLabels(0);
    InitStatLabels(1);
    lblBonus[0] = UILabel(FindChild('TeamBonus', true));
    lblBonus[1] = UILabel(FindChild('TeamBonusB', true));
    //return;    
}

function InitColumnHeaders()
{
    local int TeamID, C, StartIdx, ScreenNum;

    ScreenNum = GetPC().m_ScoreboardPage;
    StartIdx = ScreenNum * 4;
    TeamID = 0;
    J0x30:

    // End:0xD5 [Loop If]
    if(TeamID < 2)
    {
        C = 0;
        J0x43:

        // End:0xCB [Loop If]
        if(C < 4)
        {
            lblStatHeaders[TeamID].lbls[C].SetValue(strStatHeaders[StartIdx + C]);
            lblSubStatHeaders[TeamID].lbls[C].SetValue(strStatValueHeaders[StartIdx + C]);
            C++;
            // [Loop Continue]
            goto J0x43;
        }
        TeamID++;
        // [Loop Continue]
        goto J0x30;
    }
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    super(UIScene_BaseFrontEnd).SceneActivated(bInitialActivation);
    myPC.PlayAmBxScript("menu_mp_scoreboard", 0);
    //return;    
}

event SceneDeactivated()
{
    super(UIScene_BaseFrontEnd).SceneDeactivated();
    myPC.StopAmBxScript("menu_mp_scoreboard");
    //return;    
}

function ScoreboardSceneActivated(UIScene ActivatedScene, bool bInitialActivation)
{
    local int I;
    local PandoraGRI PGRI;

    // End:0x4C9
    if(bInitialActivation)
    {
        imgBackground = UIImage(FindChild('UIImage', true));
        imgBlueBacking = UIImage(FindChild('BLUE_team_backing', true));
        imgRedBacking = UIImage(FindChild('RED_team_backing', true));
        lblHelperText = UILabel(FindChild('SPUIButtonBar_2', true));
        lblIntermission = UILabel(FindChild('IntermissionLabel', true));
        btnPlayer[0] = UILabelButton(FindChild('btnPlayerA1', true));
        btnPlayer[1] = UILabelButton(FindChild('btnPlayerA2', true));
        btnPlayer[2] = UILabelButton(FindChild('btnPlayerA3', true));
        btnPlayer[3] = UILabelButton(FindChild('btnPlayerA4', true));
        btnPlayer[4] = UILabelButton(FindChild('btnPlayerB1', true));
        btnPlayer[5] = UILabelButton(FindChild('btnPlayerB2', true));
        btnPlayer[6] = UILabelButton(FindChild('btnPlayerB3', true));
        btnPlayer[7] = UILabelButton(FindChild('btnPlayerB4', true));
        lblPlayer[0] = UILabel(FindChild('lblPlayerA1', true));
        lblPlayer[1] = UILabel(FindChild('lblPlayerA2', true));
        lblPlayer[2] = UILabel(FindChild('lblPlayerA3', true));
        lblPlayer[3] = UILabel(FindChild('lblPlayerA4', true));
        lblPlayer[4] = UILabel(FindChild('lblPlayerB1', true));
        lblPlayer[5] = UILabel(FindChild('lblPlayerB2', true));
        lblPlayer[6] = UILabel(FindChild('lblPlayerB3', true));
        lblPlayer[7] = UILabel(FindChild('lblPlayerB4', true));
        UIPlayerTalkingImage[0] = UIImage(FindChild('imgTeam1Player1Talking', true));
        UIPlayerTalkingImage[1] = UIImage(FindChild('imgTeam1Player2Talking', true));
        UIPlayerTalkingImage[2] = UIImage(FindChild('imgTeam1Player3Talking', true));
        UIPlayerTalkingImage[3] = UIImage(FindChild('imgTeam1Player4Talking', true));
        UIPlayerTalkingImage[4] = UIImage(FindChild('imgTeam2Player1Talking', true));
        UIPlayerTalkingImage[5] = UIImage(FindChild('imgTeam2Player2Talking', true));
        UIPlayerTalkingImage[6] = UIImage(FindChild('imgTeam2Player3Talking', true));
        UIPlayerTalkingImage[7] = UIImage(FindChild('imgTeam2Player4Talking', true));
        MMBar1 = UIProgressBar(FindChild('MonsterMachine_fill_Order', true));
        MMBar2 = UIProgressBar(FindChild('MonsterMachine_fill_Chaos', true));
        MMLabel1 = UILabel(FindChild('TeamBonus', true));
        MMLabel2 = UILabel(FindChild('TeamBonusB', true));
        InitLabels();
        InitColumnHeaders();
        lblWinStatus = UILabel(FindChild('lblWinStatus', true));
        AlignPlayerLabels();
        lblWinStatus.SetVisibility(false);
        I = 0;
        J0x41B:

        // End:0x47A [Loop If]
        if(I < 8)
        {
            UIPlayerTalkingImage[I].SetVisibility(false);
            UIPlayerTalkingImage[I].ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
            PRIIdx[I] = -1;
            I++;
            // [Loop Continue]
            goto J0x41B;
        }
        PGRI = PandoraGRI(GetWorldInfo().GRI);
        // End:0x4A9
        if(PGRI == none)
        {
            return;            
        }
        else
        {
            SetInGameMode(!PGRI.IsInPostGame());
        }
    }
    // End:0x4F5
    if(PGRI.IsInPostGame())
    {
        PGRI.bStartMatchCountdown = false;        
    }
    else
    {
        bDisplayCursor = false;
    }
    SetHelperText();
    UpdateScoring(true);
    //return;    
}

function SetHelperText()
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return;
    }
    lblHelperText = UILabel(FindChild('SPUIButtonBar_2', true));
    // End:0x52
    if(lblHelperText == none)
    {
    }
    // End:0x73
    if(bInGameMode)
    {
        lblHelperText.SetVisibility(false);        
    }
    else
    {
        lblHelperText.SetVisibility(true);
        // End:0xD7
        if(PGRI.bIsArbitrated)
        {
            lblHelperText.SetDataStoreBinding(PlatformStrings $ "HelperText.ScoreBoardBarRanked>");            
        }
        else
        {
            // End:0x121
            if(IsSystemLinkMatch())
            {
                lblHelperText.SetDataStoreBinding(PlatformStrings $ "HelperText.ScoreBoardBarSysLink>");                
            }
            else
            {
                // End:0x177
                if(GetWorldInfo().IsConsoleBuild(1))
                {
                    lblHelperText.SetDataStoreBinding(PlatformStrings $ "HelperText.ScoreBoardBarRanked>");                    
                }
                else
                {
                    lblHelperText.SetDataStoreBinding(PlatformStrings $ "HelperText.ScoreBoardBar>");
                }
            }
        }
    }
    //return;    
}

function NotifyGameInfoReadyToEnd()
{
    local PandoraGameInfo PGI;
    local PandoraPlayerController PC;

    // End:0x61
    if(int(GetWorldInfo().NetMode) == int(NM_ListenServer))
    {
        PGI = PandoraGameInfo(GetWorldInfo().Game);
        // End:0x5E
        if(PGI != none)
        {
            PGI.bIsReadyToEnd = true;            
        }        
    }
    else
    {
        // End:0xB2
        foreach GetWorldInfo().AllControllers(Class'PandoraPlayerController', PC)
        {
            // End:0xB1
            if(PC.IsLocalPlayerController())
            {
                PC.EndOnlineGame();
                // End:0xB2
                break;
            }            
        }        
    }
    //return;    
}

function SetPlayerEntryVisibility(int Idx, bool bShow)
{
    local int I;

    // End:0x2C
    if(bInGameMode)
    {
        lblPlayer[Idx].SetVisibility(bShow);        
    }
    else
    {
        btnPlayer[Idx].SetVisibility(bShow);
    }
    I = 0;
    J0x53:

    // End:0xBC [Loop If]
    if(I < 4)
    {
        // End:0xB2
        if(lblStats[Idx].lbls[I] != none)
        {
            lblStats[Idx].lbls[I].SetVisibility(bShow);
        }
        I++;
        // [Loop Continue]
        goto J0x53;
    }
    MenuItems[Idx].bDisabled = !bShow;
    //return;    
}

function int GetNumPlayersOnTeam(int TeamID)
{
    local PandoraGRI PGRI;
    local int I, TeamCount;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    I = 0;
    J0x26:

    // End:0x84 [Loop If]
    if(I < PGRI.PRIArray.Length)
    {
        // End:0x7A
        if(PGRI.PRIArray[I].Team.TeamIndex == TeamID)
        {
            TeamCount++;
        }
        I++;
        // [Loop Continue]
        goto J0x26;
    }
    return TeamCount;
    //return ReturnValue;    
}

function int GetTeamTotalScore(int Team)
{
    local int Total, I;

    Total = 0;
    switch(Team)
    {
        // End:0x56
        case 0:
            I = 0;
            J0x1A:

            // End:0x50 [Loop If]
            if(I < TeamAStats.Length)
            {
                Total += (GetTotalPoints(TeamAStats[I]));
                I++;
                // [Loop Continue]
                goto J0x1A;
            }
            return Total;
        // End:0x9D
        case 1:
            I = 0;
            J0x61:

            // End:0x97 [Loop If]
            if(I < TeamBStats.Length)
            {
                Total += (GetTotalPoints(TeamBStats[I]));
                I++;
                // [Loop Continue]
                goto J0x61;
            }
            return Total;
        // End:0xFFFF
        default:
            return 0;
            break;
    }
    //return ReturnValue;    
}

function AssignStatLabels(int PlayerID, PlayerStats Stats)
{
    local int ScreenNum;

    ScreenNum = GetPC().m_ScoreboardPage;
    switch(ScreenNum)
    {
        // End:0xFD
        case 0:
            lblStats[PlayerID].lbls[0].SetValue(string(GetTotalKills(Stats)));
            lblStats[PlayerID].lbls[1].SetValue(string(Stats.Deaths));
            lblStats[PlayerID].lbls[2].SetValue(string(Stats.AnimusBanked));
            lblStats[PlayerID].lbls[3].SetValue(string(GetTotalPoints(Stats)));
            // End:0x2CB
            break;
        // End:0x1EA
        case 1:
            lblStats[PlayerID].lbls[0].SetValue(string(GetTotalWWKills(Stats)));
            lblStats[PlayerID].lbls[1].SetValue(string(GetTotalPlayerKills(Stats)));
            lblStats[PlayerID].lbls[2].SetValue(string(Stats.AnimusCollectedPlayerNum + Stats.AnimusCollectedWWNum));
            lblStats[PlayerID].lbls[3].SetValue(string(Stats.KillPlayerInterruptNum));
            // End:0x2CB
            break;
        // End:0x2C8
        case 2:
            lblStats[PlayerID].lbls[0].SetValue(string(Stats.KillAlphaWWNum));
            lblStats[PlayerID].lbls[1].SetValue(string(Stats.KillWeakWWNum));
            lblStats[PlayerID].lbls[2].SetValue(string(Stats.AnimusCollectedWWNum));
            lblStats[PlayerID].lbls[3].SetValue(string(Stats.AnimusCollectedPlayerNum));
            // End:0x2CB
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function UpdateTotals()
{
    local int teamIdx, ColumnIdx, PlayerIdx, TeamStartIdx, Total, Value;

    teamIdx = 0;
    J0x07:

    // End:0x10A [Loop If]
    if(teamIdx < 2)
    {
        ColumnIdx = 0;
        J0x1A:

        // End:0x100 [Loop If]
        if(ColumnIdx < 4)
        {
            Total = 0;
            TeamStartIdx = 4 * teamIdx;
            PlayerIdx = 0;
            J0x43:

            // End:0xC8 [Loop If]
            if(PlayerIdx < 4)
            {
                // End:0xBE
                if(lblStats[TeamStartIdx + PlayerIdx].lbls[ColumnIdx] != none)
                {
                    Value = int(lblStats[TeamStartIdx + PlayerIdx].lbls[ColumnIdx].GetValue());
                    Total += Value;
                }
                PlayerIdx++;
                // [Loop Continue]
                goto J0x43;
            }
            lblTotals[teamIdx].lbls[ColumnIdx].SetValue(string(Total));
            ColumnIdx++;
            // [Loop Continue]
            goto J0x1A;
        }
        teamIdx++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function UpdateScoring(optional bool bOverrideGameStatus)
{
    local PandoraGRI PGRI;
    local int LastTeamAPlayer, LastTeamBPlayer, I, StatIdx, NumStats;

    local string WinText;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2D
    if(PGRI == none)
    {
        return;
    }
    // End:0x86
    if((bOverrideGameStatus || int(PGRI.GameStatus) == int(2)) || !GetWorldInfo().IsConsoleBuild())
    {
        BuildStatLists();
        ComputeTotals();        
    }
    else
    {
        UpdateStatListNames();
    }
    LastTeamAPlayer = 0;
    LastTeamBPlayer = 0;
    // End:0xC1
    if(TeamAStats.Length < (TeamAScrollPos + 4))
    {
        NumStats = TeamAStats.Length;        
    }
    else
    {
        NumStats = TeamAScrollPos + 4;
    }
    I = TeamAScrollPos;
    J0xDB:

    // End:0x293 [Loop If]
    if(I < TeamAStats.Length)
    {
        // End:0x18A
        if(bInGameMode)
        {
            lblPlayer[LastTeamAPlayer].SetValue(TeamAStats[I].PlayerName);
            // End:0x162
            if(TeamAStats[I].bInActive)
            {
                lblPlayer[LastTeamAPlayer].StringRenderComponent.SetColor(DisabledColor);                
            }
            else
            {
                lblPlayer[LastTeamAPlayer].StringRenderComponent.SetColor(EnabledColor);
            }            
        }
        else
        {
            btnPlayer[LastTeamAPlayer].SetCaption(TeamAStats[I].PlayerName);
            // End:0x1F1
            if(LastTeamAPlayer == CurrMenuItemIdx)
            {
                btnPlayer[LastTeamAPlayer].StringRenderComponent.SetColor(SelectedColor);                
            }
            else
            {
                // End:0x233
                if(TeamAStats[I].bInActive)
                {
                    btnPlayer[LastTeamAPlayer].StringRenderComponent.SetColor(DisabledColor);                    
                }
                else
                {
                    btnPlayer[LastTeamAPlayer].StringRenderComponent.SetColor(EnabledColor);
                }
            }
        }
        AssignStatLabels(LastTeamAPlayer, TeamAStats[I]);
        SetPlayerEntryVisibility(LastTeamAPlayer, true);
        LastTeamAPlayer++;
        I++;
        // [Loop Continue]
        goto J0xDB;
    }
    // End:0x2B6
    if(TeamBStats.Length < (TeamBScrollPos + 4))
    {
        NumStats = TeamBStats.Length;        
    }
    else
    {
        NumStats = TeamBScrollPos + 4;
    }
    I = TeamBScrollPos;
    J0x2D0:

    // End:0x496 [Loop If]
    if(I < NumStats)
    {
        StatIdx = 4 + LastTeamBPlayer;
        // End:0x38D
        if(bInGameMode)
        {
            lblPlayer[StatIdx].SetValue(TeamBStats[I].PlayerName);
            // End:0x365
            if(TeamBStats[I].bInActive)
            {
                lblPlayer[StatIdx].StringRenderComponent.SetColor(DisabledColor);                
            }
            else
            {
                lblPlayer[StatIdx].StringRenderComponent.SetColor(EnabledColor);
            }            
        }
        else
        {
            btnPlayer[StatIdx].SetCaption(TeamBStats[I].PlayerName);
            // End:0x3F4
            if(StatIdx == CurrMenuItemIdx)
            {
                btnPlayer[StatIdx].StringRenderComponent.SetColor(SelectedColor);                
            }
            else
            {
                // End:0x436
                if(TeamBStats[I].bInActive)
                {
                    btnPlayer[StatIdx].StringRenderComponent.SetColor(DisabledColor);                    
                }
                else
                {
                    btnPlayer[StatIdx].StringRenderComponent.SetColor(EnabledColor);
                }
            }
        }
        AssignStatLabels(StatIdx, TeamBStats[I]);
        SetPlayerEntryVisibility(StatIdx, true);
        LastTeamBPlayer++;
        I++;
        // [Loop Continue]
        goto J0x2D0;
    }
    UpdateTotals();
    // End:0x4C9
    if((GetTeamTotalScore(0)) > (GetTeamTotalScore(1)))
    {
        WinText = strTeamAWins;        
    }
    else
    {
        // End:0x4F2
        if((GetTeamTotalScore(1)) > (GetTeamTotalScore(0)))
        {
            WinText = strTeamBWins;            
        }
        else
        {
            WinText = strTie;
        }
    }
    lblWinStatus.SetValue(WinText);
    I = LastTeamAPlayer;
    J0x51D:

    // End:0x55E [Loop If]
    if(I < 4)
    {
        SetPlayerEntryVisibility(I, false);
        UIPlayerTalkingImage[I].SetVisibility(false);
        I++;
        // [Loop Continue]
        goto J0x51D;
    }
    I = LastTeamBPlayer;
    J0x569:

    // End:0x5B2 [Loop If]
    if(I < 4)
    {
        SetPlayerEntryVisibility(I + 4, false);
        UIPlayerTalkingImage[I + 4].SetVisibility(false);
        I++;
        // [Loop Continue]
        goto J0x569;
    }
    UpdateMonsterMachineMeters();
    //return;    
}

event InitScene()
{
    __OnSceneActivated__Delegate = ScoreboardSceneActivated;
    __OnRawInputKey__Delegate = CustomInputKey;
    super(UIScene_BaseFrontEnd).InitScene();
    SetHelperText();
    //return;    
}

function ShowGamercard(int MenuIndex)
{
    local PandoraGRI PGRI;
    local int Idx;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return;
    }
    // End:0x74
    if(MenuIndex < 4)
    {
        Idx = TeamAScrollPos + MenuIndex;
        ShowGamerCardByUID(TeamAStats[TeamAScrollPos + MenuIndex].UniqueId);        
    }
    else
    {
        Idx = (TeamBScrollPos + MenuIndex) - 4;
        ShowGamerCardByUID(TeamBStats[Idx].UniqueId);
    }
    //return;    
}

function bool IsInputAltAccept(const InputEventParameters EventParms)
{
    // End:0x7A
    if(((EventParms.InputKeyName == 'XboxTypeS_Y') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'SpaceBar') && int(EventParms.EventType) == int(0))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function SwitchScoreScreen(optional bool CycleForward = true)
{
    local PandoraPlayerController PC;

    PC = GetPC();
    // End:0x22
    if(PC == none)
    {
        return;
    }
    // End:0x3F
    if(CycleForward)
    {
        PC.m_ScoreboardPage++;        
    }
    else
    {
        PC.m_ScoreboardPage--;
    }
    // End:0x8A
    if(PC.m_ScoreboardPage >= 3)
    {
        PC.m_ScoreboardPage = 0;
        // End:0x8A
        if(bInGameMode)
        {
            Close();
        }
    }
    // End:0xC7
    if(PC.m_ScoreboardPage < 0)
    {
        PC.m_ScoreboardPage = 3 - 1;
        // End:0xC7
        if(bInGameMode)
        {
            Close();
        }
    }
    PlayUISound('Clicked');
    InitColumnHeaders();
    UpdateScoring();
    //return;    
}

function bool ArePlayersListed()
{
    // End:0x31
    if(MenuItems[0].bDisabled && MenuItems[4].bDisabled)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    local PandoraPlayerController PPC;
    local bool rval;

    UpDateUsingGamePadForPC(EventParms);
    // End:0x58
    if(bInGameMode)
    {
        // End:0x37
        if(IsInputNavRight(EventParms))
        {
            SwitchScoreScreen(true);
            return true;
        }
        // End:0x56
        if(IsInputNavLeft(EventParms))
        {
            SwitchScoreScreen(false);
            return true;
        }
        return false;
    }
    PPC = GetPC();
    // End:0x26D
    if(!PPC.IsMoviePlaying())
    {
        // End:0x9E
        if(IsInputNavRight(EventParms))
        {
            SwitchScoreScreen(true);
        }
        // End:0xBB
        if(IsInputNavLeft(EventParms))
        {
            SwitchScoreScreen(false);
        }
        // End:0x138
        if((IsInputNavUp(EventParms)) && ArePlayersListed())
        {
            // End:0x10B
            if((CurrMenuItemIdx == 0) && TeamAScrollPos > 0)
            {
                TeamAScrollPos--;
                UpdateScoring();
                return true;                
            }
            else
            {
                // End:0x138
                if((CurrMenuItemIdx == 4) && TeamBScrollPos > 0)
                {
                    TeamBScrollPos--;
                    UpdateScoring();
                    return true;
                }
            }
        }
        // End:0x1D2
        if((IsInputNavDown(EventParms)) && ArePlayersListed())
        {
            // End:0x195
            if((CurrMenuItemIdx == (4 - 1)) && TeamAScrollPos < (TeamAStats.Length - 4))
            {
                TeamAScrollPos++;
                UpdateScoring();
                return true;                
            }
            else
            {
                // End:0x1D2
                if((CurrMenuItemIdx == ((4 + 4) - 1)) && TeamBScrollPos < (TeamBStats.Length - 4))
                {
                    TeamBScrollPos++;
                    UpdateScoring();
                    return true;
                }
            }
        }
        // End:0x1F0
        if(IsInputNavShoulderL(EventParms))
        {
            ShowPlayersUI();
            return true;
        }
        // End:0x213
        if(IsInputAltAccept(EventParms))
        {
            ShowGamercard(CurrMenuItemIdx);
            return true;
        }
        // End:0x26D
        if((IsInputCancel(EventParms)) || IsInputEscape(EventParms))
        {
            PlayUISound('SceneClosed');
            ShowMsgBox(QuitToMainMessage, QuitToMainTitle, 1, OnAbortSessionCB);
            return true;
        }
    }
    // End:0x37C
    if((IsInputAccept(EventParms)) || IsInputEscape(EventParms))
    {
        // End:0x2D0
        if(bLostConnectionToHost)
        {
            PlayUISound('SceneClosed');
            ShowMsgBox(QuitToMainMessage, QuitToMainTitle, 1, OnAbortSessionCB);
            return true;
        }
        // End:0x2FB
        if(PPC.IsMoviePlaying())
        {
            Class'Engine.GameEngine'.static.StopMovie(false);            
        }
        else
        {
            PlayUISound('SceneClosed');
            // End:0x358
            if((GetWorldInfo().GRI != none) && !GetWorldInfo().GRI.bIsArbitrated)
            {
                SkipToLobby();                
            }
            else
            {
                ShowMsgBox(QuitToMainMessage, QuitToMainTitle, 1, OnAbortSessionCB);
            }
        }
        return true;
    }
    // End:0x3A6
    if(bGRIInitialized && ArePlayersListed())
    {
        rval = super(UIScene_BaseFrontEnd).CustomInputKey(EventParms);
    }
    // End:0x3BA
    if(rval)
    {
        UpdateScoring();
    }
    return rval;
    //return ReturnValue;    
}

function SkipToLobby()
{
    local PandoraPlayerController PPC;
    local UIScene_PandoraLobbyMP LobbyScene;
    local SPPlayerReplicationInfo SPPRI;

    PPC = GetPC();
    SPPRI = SPPlayerReplicationInfo(PPC.PlayerReplicationInfo);
    SPPRI.RequestSkipIntermission(true);
    SPPRI.RequestReadyStatusChange(false);
    PandoraGRI(GetWorldInfo().GRI).bStartMatchCountdown = false;
    Close();
    PPC.CloseSceneType(Class'UIScene_MPMenu');
    LobbyScene = UIScene_PandoraLobbyMP(DynamicLoadObject("PandoraShellLobby.PandoraXeLobby", Class'UIScene_PandoraLobbyMPXenon'));
    PPC.ClientOpenLobbyScene(LobbyScene);
    //return;    
}

function OnAbortSessionCB(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x12
    if(int(eReturnValue) != int(1))
    {
        return;
    }
    GetPC().DestroySession();
    GetPC().ClientTravel("pandorastart", 0);
    //return;    
}

function bool RequiresNetworkUpdates()
{
    return true;
    //return ReturnValue;    
}

function AlignPlayerLabels()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x48 [Loop If]
    if(I < 8)
    {
        lblPlayer[I].Position = btnPlayer[I].Position;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function UpdateIntermissionText(WorldInfo WorldInfo, float DeltaTime)
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x12E
    if(((PGRI != none) && PGRI.IsInPostGame()) && !PGRI.bIsArbitrated)
    {
        // End:0x118
        if(PGRI.IntermissionTimeRemaining >= 0)
        {
            // End:0x9D
            if(PGRI.IntermissionTimeRemaining == 0)
            {
                Close();
                PGRI.CloseScoreboard();
            }
            // End:0xE6
            if(PGRI.IntermissionTimeRemaining < 10)
            {
                lblIntermission.SetDataStoreBinding((strIntermission $ ":  ") $ string(PGRI.IntermissionTimeRemaining));                
            }
            else
            {
                lblIntermission.SetDataStoreBinding((strIntermission $ ": ") $ string(PGRI.IntermissionTimeRemaining));
            }            
        }
        else
        {
            lblIntermission.SetDataStoreBinding("");
        }        
    }
    else
    {
        lblIntermission.SetDataStoreBinding("");
    }
    //return;    
}

function SetInGameMode(bool bIsInGame)
{
    local int I;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    I = 0;
    J0x26:

    // End:0xB0 [Loop If]
    if(I < 8)
    {
        // End:0x72
        if(bIsInGame)
        {
            btnPlayer[I].SetVisibility(false);
            MenuItems[I].bDisabled = true;
            // [Explicit Continue]
            goto J0xA6;
        }
        lblPlayer[I].SetVisibility(false);
        MenuItems[I].bDisabled = false;
        J0xA6:

        I++;
        // [Loop Continue]
        goto J0x26;
    }
    // End:0x142
    if(bIsInGame)
    {
        imgBackground.SetVisibility(false);
        imgBlueBacking.SetVisibility(false);
        imgRedBacking.SetVisibility(false);
        lblHelperText.SetVisibility(false);
        lblWinStatus.SetVisibility(false);
        lblIntermission.SetVisibility(false);
        SetSceneInputMode(0);        
    }
    else
    {
        imgBackground.SetVisibility(true);
        imgBlueBacking.SetVisibility(true);
        imgRedBacking.SetVisibility(true);
        lblHelperText.SetVisibility(true);
        lblWinStatus.SetVisibility(true);
        lblIntermission.SetVisibility(true);
        SetSceneInputMode(3);
        // End:0x1D6
        if(PGRI == none)
        {            
        }
        else
        {
            PGRI.FreezePawns();
        }
        PGRI.GameStatus = 6;
    }
    bInGameMode = bIsInGame;
    //return;    
}

function Close()
{
    SceneClient.CloseScene(self);
    //return;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    LastUpdateTime += DeltaTime;
    // End:0x31
    if(LastUpdateTime >= 0.5000000)
    {
        UpdateScoring();
        LastUpdateTime = 0.0000000;
    }
    UpdateIntermissionText(WorldInfo, DeltaTime);
    UpdateTalking(DeltaTime);
    HandleGRIInitialized();
    super(UIScene_BaseFrontEnd).UpdateScene(DeltaTime, WorldInfo);
    //return;    
}

function HandleGRIInitialized()
{
    local PandoraGRI PGRI;

    // End:0x52
    if(!bGRIInitialized)
    {
        PGRI = PandoraGRI(GetWorldInfo().GRI);
        // End:0x52
        if(PGRI != none)
        {
            bGRIInitialized = true;
            UpdateScoring(true);
            UpdateStatListNames();
        }
    }
    //return;    
}

function UpdateTalking(float DeltaTime)
{
    local PandoraGRI PGRI;
    local SPPlayerReplicationInfo SPPRI;
    local int LastTeamAPlayer, LastTeamBPlayer, I, StatIdx;
    local bool bMuted;

    LastTeamAPlayer = 0;
    LastTeamBPlayer = 0;
    // End:0x19
    if(bLostConnectionToHost)
    {
        return;
    }
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x45
    if(PGRI == none)
    {
        return;
    }
    I = 0;
    J0x4C:

    // End:0x25D [Loop If]
    if(I < PGRI.PRIArray.Length)
    {
        SPPRI = SPPlayerReplicationInfo(PGRI.PRIArray[I]);
        // End:0x253
        if((SPPRI != none) && !SPPRI.bBot)
        {
            // End:0xDC
            if(SPPRI.Team.TeamIndex == 1)
            {
                StatIdx = LastTeamAPlayer;
                LastTeamAPlayer++;                
            }
            else
            {
                // End:0x112
                if(SPPRI.Team.TeamIndex == 2)
                {
                    StatIdx = 4 + LastTeamBPlayer;
                    LastTeamBPlayer++;
                }
            }
            // End:0x16B
            if(GetPC().PlayerReplicationInfo != PGRI.PRIArray[I])
            {
                bMuted = GetPC().IsRemotePlayerMuted(SPPRI.UniqueId);
            }
            // End:0x21B
            if(SPPRI.bHeadsetPresent)
            {
                UIPlayerTalkingImage[StatIdx].SetVisibility(PGRI.OnSameTeam(GetPC(), SPPRI));
                // End:0x1FB
                if(SPPRI.bIsTalking && !bMuted)
                {
                    UIPlayerTalkingImage[StatIdx].ActivateStateByClass(Class'Engine.UIState_Enabled', 0);                    
                }
                else
                {
                    UIPlayerTalkingImage[StatIdx].ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
                }
                // [Explicit Continue]
                goto J0x253;
            }
            UIPlayerTalkingImage[StatIdx].ActivateStateByClass(Class'Engine.UIState_Disabled', 0);
            UIPlayerTalkingImage[StatIdx].SetVisibility(false);
        }
        J0x253:

        I++;
        // [Loop Continue]
        goto J0x4C;
    }
    //return;    
}

function UpdateMonsterMachineMeters()
{
    local PandoraGRI PGRI;
    local int monsterMachineLevelPoints, fillLevel;
    local WorldInfo WI;
    local SPPointEventMachineBonusPersistent theMachineBonus;

    WI = Class'SPHud'.static.GetWorldInfo();
    PGRI = PandoraGRI(WI.GRI);
    // End:0x45
    if(PGRI == none)
    {
        monsterMachineLevelPoints = 0;        
    }
    else
    {
        theMachineBonus = PGRI.GetPointEventMachineBonus();
        fillLevel = theMachineBonus.GetLevelForFillPercent(int(PGRI.GetMonsterMachineValue(1)));
        monsterMachineLevelPoints = theMachineBonus.GetPointsForLevel(fillLevel);
        MMLabel1.SetValue("+" $ string(monsterMachineLevelPoints));
        MMBar1.SetValue(float(PGRI.GetMonsterMachineValue(1)));
        fillLevel = theMachineBonus.GetLevelForFillPercent(int(PGRI.GetMonsterMachineValue(2)));
        monsterMachineLevelPoints = theMachineBonus.GetPointsForLevel(fillLevel);
        MMBar2.SetValue(float(PGRI.GetMonsterMachineValue(2)));
        MMLabel2.SetValue("+" $ string(monsterMachineLevelPoints));
    }
    //return;    
}

function ChildSceneOpened(UIScene NewTopScene)
{
    local WorldInfo WorldInfo;
    local PandoraGRI PGRI;

    WorldInfo = GetWorldInfo();
    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0xAE
    if(!bInGameMode && int(WorldInfo.NetMode) == int(NM_ListenServer))
    {
        // End:0xAE
        if(int(GetLoginStatus(LocPlayer.ControllerId)) == int(0))
        {
            PGRI.IntermissionTimeRemaining = -1;
            WorldInfo.Game.ClearTimer('IntermissionTimer');
        }
    }
    //return;    
}
